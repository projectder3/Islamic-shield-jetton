contract DERWalletMaster {
    // العناوين
    address owner = 0:28b8a98a1cbe6b9acfc0dc9ff6e739c9e128bf7c87b046cadfbc28c10d06fb58;
    address project_treasure = 0:A1906487e4130684c7fb397d9af7f36b1eba366091d2a7e499352e1b73327809;
    address transaction_log;

    // المتغيرات
    int balance = 0;

    // الثوابت
    const FEE_PERCENT = 1;                       // 1%
    const FEE_CAP = 1000 * 10^9;                 // 1000 DER
    const FIXED_GAS_FEE = 200_000_000;           // 0.2 TON
    const MIN_REFUND = 50_000_000;               // 0.05 TON

    // منشئ العقد
    public fun constructor() {
        transaction_log = 0:0000000000000000000000000000000000000000000000000000000000000000;
    }

    // استقبال التوكنات
    public fun receive_tokens(int amount) {
        balance += amount;
    }

    // التحويل إلى عنوان آخر
    public fun transfer(address to, int amount) {
        require(msg.value >= FIXED_GAS_FEE, "Insufficient gas fee");
        require(balance >= amount, "Insufficient balance");

        // احتساب العمولة
        int fee = amount / 100;
        if (fee > FEE_CAP) {
            fee = FEE_CAP;
        }
        int amount_after_fee = amount - fee;

        // تنفيذ التحويل والخصم
        balance -= amount;
        send(to).receive_tokens(amount_after_fee);
        send(project_treasure).receive_tokens(fee);

        // تسجيل العملية (إن وُجد سجل)
        if (transaction_log != 0:0000000000000000000000000000000000000000000000000000000000000000) {
            send(transaction_log).record_transaction(sender, to, amount, fee);
        }

        // استرداد الباقي من رسوم الغاز إن كان أكبر من 0.05 TON
        int refund = msg.value - FIXED_GAS_FEE;
        if (refund > MIN_REFUND) {
            send_raw(sender, refund);
        }
    }

    // تعيين سجل المعاملات مرة واحدة فقط
    public fun set_transaction_log(address log_address) {
        require(transaction_log == 0:0000000000000000000000000000000000000000000000000000000000000000, "Log already set");
        transaction_log = log_address;
    }

    // منع وظائف mint و burn
    public fun mint(int amount) {
        revert("Minting is disabled");
    }

    public fun burn(int amount) {
        revert("Burning is disabled");
    }

    // استعلامات
    get get_balance(): int {
        return balance;
    }

    get get_owner(): address {
        return owner;
    }

    get get_project_treasure(): address {
        return project_treasure;
    }

    get get_transaction_log(): address {
        return transaction_log;
    }
}
