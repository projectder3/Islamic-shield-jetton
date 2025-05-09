contract DERToken {
    // تحديد المعلومات الأساسية للعملة
    const total_supply: int = 100_100_000 * 10^9; // إجمالي المعروض
    const name: string = "Islamic Economic Shield"; // اسم العملة
    const symbol: string = "DER"; // الرمز
    const decimals: int = 9; // عدد المنازل العشرية

    // رابط الصورة الخاصة بالعملة
    const image_url: string = "https://violet-negative-whale-504.mypinata.cloud/ipfs/bafybeidaqstetyks7sb2igwqstq6ad6zoghznbzcnta46t3ujmwxhhzxli";

    // تعريف المتغيرات الخاصة بالمخزون
    map<address, int> balances; // خريطة لتخزين الرصيد لكل عنوان
    address owner = 0:28b8a98a1cbe6b9acfc0dc9ff6e739c9e128bf7c87b046cadfbc28c10d06fb58; // مالك العملة

    // دالة init لتخصيص التوكنات للمالك عند نشر العقد
    init() {
        balances[owner] = total_supply; // تخصيص كامل المعروض للمالك
    }

    // دالة لنقل التوكنات بين العناوين
    public fun transfer(to: address, amount: int) {
        require(balances[sender] >= amount, "Insufficient balance"); // التأكد من وجود رصيد كافي
        require(msg.gas > 0, "Gas fee must be paid by sender"); // التأكد من أن المرسل دفع رسوم الغاز

        balances[sender] -= amount; // خصم التوكنات من المرسل
        balances[to] += amount; // إضافة التوكنات للمستلم
    }

    // دالة لإرجاع رابط الصورة الخاصة بالعملة
    get token_image(): string {
        return image_url; // إرجاع رابط الصورة
    }

    // دالة للحصول على الرصيد لأي عنوان
    get balance_of(addr: address): int {
        return balances.get(addr, 0); // إرجاع الرصيد الحالي للعنوان
    }
}
