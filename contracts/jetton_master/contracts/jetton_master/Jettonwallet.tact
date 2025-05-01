contract JettonWallet {
    // عنوان المالك (محفظة المالك)
    address public owner = 0xEQAouKmKHL5rms_A3J_25znJ4Si_fIewRsrfvCjBDQb7WHum;

    // عنوان محفظة الخزينة
    address public treasuryAddress = 0xEQChkGSH5BMGhMf7OX2a9_NrHro2YJHS.p-SZNS4bczJ4Cfu1;

    // عنوان العقد الرئيسي (Jetton Master)
    address public masterContract;

    // الحد الأقصى للرصيد
    uint256 public totalSupply;

    // تخزين رصيد كل محفظة
    mapping(address => uint256) public balances;

    // دالة التهيئة
    constructor(address _masterContract) {
        // تخزين عنوان العقد الرئيسي عند الإنشاء
        masterContract = _masterContract;
    }

    // تعديل الرسوم (1٪) عند التحويل
    modifier chargeTransactionFee(uint256 amount) {
        uint256 fee = amount / 100;  // 1٪ من المبلغ
        uint256 amountAfterFee = amount - fee;
        
        // إرسال الرسوم إلى محفظة الخزينة
        send(treasuryAddress, fee);
        
        // تنفيذ العملية بعد خصم الرسوم
        _;
    }

    // وظيفة لتحويل الأموال بين المحافظ
    public function transfer(address recipient, uint256 amount) public chargeTransactionFee(amount) {
        require(recipient != address(0), "Invalid recipient address");
        require(amount <= balances[msg.sender], "Insufficient balance");

        // تنفيذ التحويل
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
    }

    // دالة لاستلام التوكنات
    public function deposit(uint256 amount) public {
        balances[msg.sender] += amount;
        totalSupply += amount;
    }

    // دالة لاسترجاع الرصيد
    public function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    // دالة لاسترجاع مجموع المعروض الكلي
    public function getTotalSupply() public view returns (uint256) {
        return totalSupply;
    }
    
    // دالة لتحويل الأموال إلى محفظة الخزينة
    private function send(address recipient, uint256 amount) private {
        // منطق إرسال الأموال إلى محفظة الخزينة
        balances[recipient] += amount;
    }
}
