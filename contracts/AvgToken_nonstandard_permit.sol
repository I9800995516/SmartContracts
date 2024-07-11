// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract AVGToken is IERC20 {
    string public name = "AVGToken";
    string public symbol = "AVG";
    uint8 public decimals = 18;
    uint256 private _totalSupply;
    address public owner;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => uint256) public nonces;

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    constructor(uint256 initialSupply) {
        owner = msg.sender;
        _mint(owner, initialSupply);
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     */
    function transfer(address to, uint256 value) external override returns (bool) {
        require(to != address(0), "Transfer to the zero address");
        require(_balances[msg.sender] >= value, "Transfer amount exceeds balance");

        _balances[msg.sender] -= value;
        _balances[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner_, address spender) external view override returns (uint256) {
        return _allowances[owner_][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     */
    function approve(address spender, uint256 value) external override returns (bool) {
        require(spender != address(0), "Approve to the zero address");

        _allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     */
    function transferFrom(address from, address to, uint256 value) external override returns (bool) {
        require(to != address(0), "Transfer to the zero address");
        require(_balances[from] >= value, "Transfer amount exceeds balance");
        require(_allowances[from][msg.sender] >= value, "Transfer amount exceeds allowance");

        _balances[from] -= value;
        _balances[to] += value;
        _allowances[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }

    /**
     * @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     */
    function _mint(address account, uint256 amount) internal onlyOwner {
        require(account != address(0), "Mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     */
    function _burn(address account, uint256 amount) internal onlyOwner {
        require(account != address(0), "Burn from the zero address");
        require(_balances[account] >= amount, "Burn amount exceeds balance");

        _balances[account] -= amount;
        _totalSupply -= amount;
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Unusual permit function mimicking behavior.
     * This is non-standard and is not following EIP-2612.
     */
    function permit(address owner_, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external {
        require(deadline >= block.timestamp, "Permit expired");

        bytes32 structHash = keccak256(
            abi.encode(
                "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)",
                owner_,
                spender,
                value,
                nonces[owner_],
                deadline
            )
        );

        bytes32 hash = keccak256(
            abi.encodePacked(
                "\x19\x01",
                domainSeparator(),
                structHash
            )
        );

        address signer = ECDSA.recover(hash, v, r, s);

        require(signer == owner_, "Invalid signature");

        nonces[owner_] += 1;
        _allowances[owner_][spender] = value;
        emit Approval(owner_, spender, value);
    }

    /**
     * @dev Returns the domain separator used in EIP-712 signatures.
     */
    function domainSeparator() public view returns (bytes32) {
        uint chainId;
        assembly {
            chainId := chainid()
        }
        return keccak256(
            abi.encode(
                keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                keccak256(bytes(name)),
                keccak256(bytes("1")),
                chainId,
                address(this)
            )
        );
    }
}
