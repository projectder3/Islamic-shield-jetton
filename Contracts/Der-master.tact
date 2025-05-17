// DERJettonMaster.tact
import "@tact/stdlib";
import { JettonMaster, JettonWallet, sendDeploy, sendToken } from "@tact/jetton";

const owner = Address("0:28b8a98a1cbe6b9acfc0dc9ff6e739c9e128bf7c87b046cadfbc28c10d06fb58"); // المالك
const airdrop = Address("0:C949a9f187f370a45c781bf7420a89d1e4cc54acf3d72e7e526bfd4c9ebe0b06");
const ico = Address("0:F224876bd49a630aa240dd078e53af8342c2efb5114c63642f8906fd34992253");
const liquidity = Address("0:38b814c314561db11821a56f448d212696d604e592982db3fa64a982a60e83c5");
const reserve = Address("0:28bb65478e517f71102b1a487ad618c74e130a94c5ba2d7eb4648fac2cf2fe32");
const treasury = Address("0:A1906487e4130684c7fb397d9af7f36b1eba366091d2a7e499352e1b73327809");

// معلومات التوكن
const jettonMetadata = {
    name: "Islamic Economic Shield",
    symbol: "DER",
    description: "DEFI HALAL ON TON",
    decimals: 9,
    image: "https://violet-negative-whale-504.mypinata.cloud/ipfs/bafybeidaqstetyks7sb2igwqstq6ad6zoghznbzcnta46t3ujmwxhhzxwm",
    // أي ميتاداتا إضافية يمكن إضافتها هنا
};

contract DERJettonMaster is JettonMaster {
    init(owner: owner, content: jettonMetadata);

    // يتم استدعاء هذا الدالة عند نشر العقد لتوزيع التوكنات
    post deploy {
        // الوحدات مضروبة في 10^9 (لتوافق Jetton)
        let amount_owner = 10_100_000_000_000n;
        let amount_airdrop = 5_000_000_000_000n;
        let amount_ico = 50_000_000_000_000n;
        let amount_reserve = 15_000_000_000_000n;
        let amount_liquidity = 20_000_000_000_000n;

        // التوزيع
        sendDeploy(owner, amount_owner);
        sendDeploy(airdrop, amount_airdrop);
        sendDeploy(ico, amount_ico);
        sendDeploy(reserve, amount_reserve);
        sendDeploy(liquidity, amount_liquidity);

        // خزينة المشروع بدون كمية أولية - يمكن استخدام wallet لاحقًا لرسوم المعاملات
        // sendDeploy(treasury, 0n);
    }
}
