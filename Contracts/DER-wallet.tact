contract DERWallet {
    address owner = 0:28b8a98a1cbe6b9acfc0dc9ff6e739c9e128bf7c87b046cadfbc28c10d06fb58;  // عنوان المالك
    address project_treasure = 0:A1906487e4130684c7fb397d9af7f36b1eba366091d2a7e499352e1b73327809;  // خزينة المشروع
    int balance = 0;

    // الرسوم: 1% بحد أقصى 1000 DER
    const FEE_PERCENT = 1;
    const FEE_CAP = 1000 * 10^9;

    // استقبال التوكنات من أي عنوان
    public fun receive_tokens(amount: int) {
        balance += amount;
    }

    // إرسال التوكنات إلى محفظة أخرى
    public fun transfer(address to, int amount) {
        require(balance >= amount, "Insufficient balance");

        // حساب الرسوم: 1% بحد أقصى 1000 DER
        int fee = amount / 100;
        if (fee > FEE_CAP) {
            fee = FEE_CAP;
        }

        int amount_after_fee = amount - fee;

        // خصم الرصيد
        balance -= amount;

        // إرسال المبلغ بعد خصم الرسوم إلى المتلقي
        send(to).receive_tokens(amount_after_fee);

        // إرسال الرسوم إلى خزينة المشروع
        send(project_treasure).receive_tokens(fee);

        // تحميل المستخدم (المتفاعل) رسوم الغاز الخاصة به الخاصة بالتحويل والعقد
        require(send_gas(sender, to, amount_after_fee, fee) == 0, "Gas fee transfer failed");
    }

    // دالة لتحميل المستخدم رسوم الغاز الخاصة به
    private fun send_gas(sender: address, to: address, amount: int, fee: int): int {
        return 0;  // محاكاة العملية
    }

    // استعلام عن الرصيد
    get get_balance(): int {
        return balance;
    }

    // استعلام عن المالك
    get get_owner(): address {
        return owner;
    }

    // استعلام عن خزينة المشروع
    get get_project_treasure(): address {
        return project_treasure;
    }
}
