// Jetton Master Contract for ISLAMIC SHIELD (DER)
import "@stdlib/deploy";
import "@stdlib/jetton/JettonRoot";
import "@stdlib/jetton/JettonWallet";

// ثابتات المشروع
const TOTAL_SUPPLY: uint128 = 100_100_000 * 10^9;
const TREASURY_ADDRESS: address = address("EQChkGSH5BMGhMf7OX2a9_NrHro2YJHS.p-SZNS4bczJ4Cfu1");

contract JettonMaster with Deployable, JettonRoot {
    address owner;

    init(owner_: address) {
        owner = owner_;
        totalSupply = TOTAL_SUPPLY;
        // التوزيع الأولي للعملات إلى المحافظ المحددة
        _mint(owner_, 10_100_000 * 10^9); // المؤسس
        _mint(address("EQDJSanxh_NwpFx4G_dCConR5MxUrPPXLn5Sa_1Mnr4LBtFY"), 5_000_000 * 10^9); // الإيردروب
        _mint(address("EQDyJIdr1JpjCqJA3QeOU6-DQsLvtRFMY2QviQb9NJkiU-qT"), 50_000_000 * 10^9); // ICO
        _mint(address("EQA4uBTDFFYdsRghpW9EjSEmltYE5ZKYLbP6ZKmCpg6DxZE6"), 20_000_000 * 10^9); // السيولة
        _mint(address("EQAou2VHjlF_cRArGkh61hjHThMKlMW6LX60ZI-sLPL-MjJS"), 15_000_000 * 10^9); // الاحتياطي
    }

    // إلغاء الحرق والإصدار
    override fun mint() {
        throw(); // منع إصدار جديد
    }

    override fun burn() {
        throw(); // منع الحرق
    }

    // تحقق من الرسوم والتحويلات
    override fun onTransfer(from: address, to: address, amount: uint128, responseAddress: address) {
        require(to != myAddress(), "Cannot send to contract itself");
        require(to != address(0), "Invalid destination address");

        let fee = amount / 100; // 1%
        let netAmount = amount - fee;

        // إرسال الرسوم إلى الخزينة
        send(TREASURY_ADDRESS, fee);

        // إرسال الباقي للمستلم
        JettonWallet(to).internalTransfer(netAmount, from, responseAddress);
    }

    // حماية متقدمة
    fallback() {
        throw(); // لا يوجد استقبال مفتوح
    }

    receive() {
        throw(); // لا يُسمح بتحويلات مباشرة
    }
}
