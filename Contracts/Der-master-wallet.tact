// Jetton Master and Wallet Combined Contract - ISLAMIC SHIELD (DER)
contract JettonMaster with jetton.Master {

    // المتغيرات الثابتة
    const TOTAL_SUPPLY: Coins = 100_100_000 * 10^9;
    const OWNER_ADDRESS: Address = address("EQAouKmKHL5rms_A3J_25znJ4Si_fIewRsrfvCjBDQb7WHum");
    const METADATA_URL: slice = "ipfs://bafybei..." as slice;
    const TREASURY_ADDRESS: Address = address("EQChkGSH5BMGhMf7OX2a9_NrHro2YJHS.p-SZNS4bczJ4Cfu1");

    // توزيع التوكن عند النشر
    deploy() {
        // تهيئة الجيتون
        jetton.init(
            name: "ISLAMIC SHIELD",
            symbol: "DER",
            decimals: 9,
            total_supply: TOTAL_SUPPLY,
            owner: OWNER_ADDRESS,
            wallet_code: this, // دمج JettonWallet هنا
            content: METADATA_URL
        );

        // توزيع التوكنات على المحافظ الخمسة
        jetton.mint(address("EQAouKmKHL5rms_A3J_25znJ4Si_fIewRsrfvCjBDQb7WHum"), 10_100_000 * 10^9); // المالك
        jetton.mint(address("EQD1AirdropWalletAddress..."), 5_000_000 * 10^9);   // الإيردروب
        jetton.mint(address("EQD2ICOAddress..."),         50_000_000 * 10^9);    // البيع الأولي
        jetton.mint(address("EQD3LiquidityAddress..."),   20_000_000 * 10^9);    // السيولة
        jetton.mint(address("EQD4ReserveAddress..."),     15_000_000 * 10^9);    // الاحتياطي
    }

    // Jetton Wallet Logic (مدمج هنا)

    receive("transfer") {
        // تأكد أن المستخدم دفع رسوم غاز كافية (مثلاً: 0.05 TON)
        if (msg.value < 50_000_000) {
            throw(201); // رسوم غير كافية
        }

        // فك بيانات الرسالة
        let body = slice(msg.body);
        let query_id = body.loadUint(64);
        let amount: Coins = body.loadCoins();
        let recipient: Address = body.loadMsgAddress();

        // حساب 1٪ رسوم
        let fee: Coins = amount / 100;
        let final_amount: Coins = amount - fee;

        // إرسال 1٪ إلى الخزينة
        send(TREASURY_ADDRESS, fee);

        // إرسال المبلغ الصافي للمستلم
        jetton.send(recipient, final_amount);

        // ملاحظات:
        // لا نُعيد أي فائض، لأن المستخدم مسؤول عن تحديد الرسوم
    }
}
