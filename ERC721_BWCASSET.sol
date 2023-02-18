// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IBEP20 {
  function totalSupply() external view returns (uint256);
  function decimals() external view returns (uint256);
  function symbol() external view returns (string memory);
  function name() external view returns (string memory);
  function getOwner() external view returns (address);
  function balanceOf(address account) external view returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
  function allowance(address _owner, address spender) external view returns (uint256);
  function approve(address spender, uint256 amount) external returns (bool);
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);

}

contract ERC721_BWCASSET is ERC721, Ownable {

  string public _uri;

  uint256 public totalSupply;
  mapping(address => bool) public permission;

  modifier onlyPermission() {
    require(permission[msg.sender], "!PERMISSION");
    _;
  }

  constructor(string memory _name, string memory _symbol)
  ERC721(_name, _symbol){ permission[msg.sender] = true; }

  struct Nft {
    uint256 id;
    uint256 date;
    uint256 rairity;
    uint256 object;
  }

  Nft[] public Nfts;

  function flagePermission(address _account,bool _flag) public onlyOwner returns (bool) {
    permission[_account] = _flag;
    return true;
  }

  function ProcessTokenRequest(address account,uint256 _nftrarity,uint256 _objecttype) external onlyPermission returns (bool) {
    Nft memory newNft = Nft(totalSupply,block.timestamp,_nftrarity,_objecttype);
    Nfts.push(newNft);
    _safeMint(account, totalSupply);
    totalSupply++;
    return true;
  }

  function updateNFTData(uint256 tokenid,uint256 _nftrarity,uint256 _objecttype) external onlyPermission returns (bool) {
    Nfts[tokenid].rairity = _nftrarity;
    Nfts[tokenid].object = _objecttype;
    return true;
  }
  
  function getNfts() public view returns (Nft[] memory) {
    return Nfts;
  }

  function getOwnerNfts(address _owner) public view returns (Nft[] memory) {
    Nft[] memory result = new Nft[](balanceOf(_owner));
    uint256 counter = 0;
    for (uint256 i = 0; i < Nfts.length; i++) {
      if (ownerOf(i) == _owner) {
        result[counter] = Nfts[i];
        counter++;
      }
    }
    return result;
  }
  
  function setBaseURI(string memory input) public onlyPermission returns (bool) {
    _uri = input;
    return true;
  }

  function _baseURI() internal view override returns (string memory) {
    return _uri;
  }

}
