// Jetton Master Contract for ISLAMIC SHIELD (DER) - TEP-74 Compliant

import "@stdlib/deploy" as deploy;
import "@stdlib/jetton" as jetton;

const TREASURY_ADDRESS: address = address("EQChkGSH5BMGhMf7OX2a9_NrHro2YJHS.p-SZNS4bczJ4Cfu1");
const OWNER_ADDRESS: address = address("EQAouKmKHL5rms_A3J_25znJ4Si_fIewRsrfvCjBDQb7WHum");

// Metadata link stored on IPFS
const METADATA_URL = "https://violet-negative-whale-504.mypinata.cloud/ipfs/bafybeidaqstetyks7sb2igwqstq6ad6zoghznbzcnta46t3ujmwxhhzxli";

// Total supply (fixed)
const TOTAL_SUPPLY: uint = 100_100_000 * 10^9; // 100.1M with 9 decimals

// Distribution wallets and allocations
const DISTRIBUTIONS = [
    { to: address("EQAouKmKHL5rms_A3J_25znJ4Si_fIewRsrfvCjBDQb7WHum"), amount: 10_100_000 * 10^9 },  // Founder
    { to: address("EQDJSanxh_NwpFx4G_dCConR5MxUrPPXLn5Sa_1Mnr4LBtFY"), amount: 5_000_000 * 10^9 },    // Airdrop
    { to: address("EQDyJIdr1JpjCqJA3QeOU6-DQsLvtRFMY2QviQb9NJkiU-qT"), amount: 50_000_000 * 10^9 },   // ICO
    { to: address("EQA4uBTDFFYdsRghpW9EjSEmltYE5ZKYLbP6ZKmCpg6DxZE6"), amount: 20_000_000 * 10^9 },   // Liquidity
    { to: address("EQAou2VHjlF_cRArGkh61hjHThMKlMW6LX60ZI-sLPL-MjJS"), amount: 15_000_000 * 10^9 }    // Reserve
];

// Jetton Wallet Implementation
contract JettonWalletImpl with jetton.Wallet {
    receive("internal_transfer") {
        let fee = msg.amount * 1 / 100;
        let amountAfterFee = msg.amount - fee;

        // Transfer 1% fee to treasury
        send(TREASURY_ADDRESS, fee, internal);

        // Forward the remaining amount
        jetton.internalForwardTransfer(msg.sender, msg.recipient, amountAfterFee);
    }

    receive("burn") {
        throw(); // mint/burn disabled permanently
    }

    receive("mint") {
        throw(); // mint/burn disabled permanently
    }
}

// Jetton Master Contract
contract JettonMaster with jetton.Master {
    deploy() {
        jetton.init(
            name: "ISLAMIC SHIELD",
            symbol: "DER",
            decimals: 9,
            total_supply: TOTAL_SUPPLY,
            owner: OWNER_ADDRESS,
            wallet_code: JettonWalletImpl,
            content: METADATA_URL
        );

        // Distribute to wallets
        for (let dist of DISTRIBUTIONS) {
            jetton.internalMint(dist.to, dist.amount);
        }
    }

    receive("mint") {
        throw(); // minting is permanently disabled
    }

    receive("burn") {
        throw(); // burning is permanently disabled
    }
}
