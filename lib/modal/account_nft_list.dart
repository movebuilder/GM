class AccountNftList {
  String? address;
  List<Nft>? nft;

  AccountNftList({this.address, this.nft});

  AccountNftList.fromJson(Map<String, dynamic> json) {
    if (json['nft'] != null) {
      nft = <Nft>[];
      json['nft'].forEach((v) {
        nft!.add(new Nft.fromJson(v));
      });
      address = nft![0].owner;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    if (this.nft != null) {
      data['nft'] = this.nft!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Nft {
  String? tokenId;
  String? owner;
  String? creator;
  String? collectionName;
  String? tokenName;
  int? propertyVersion;
  String? collectionId;
  String? collectionSlug;
  String? seller;
  String? tokenUri;
  String? previewUri;
  bool? isListed;
  int? price;
  String? highestBid;

  // String? metadatas;

  Nft({
    this.tokenId,
    this.owner,
    this.creator,
    this.collectionName,
    this.tokenName,
    this.propertyVersion,
    this.collectionId,
    this.collectionSlug,
    this.seller,
    this.tokenUri,
    this.previewUri,
    this.isListed,
    this.price,
    this.highestBid,
    //this.metadatas
  });

  Nft.fromJson(Map<String, dynamic> json) {
    tokenId = json['token_id'];
    owner = json['owner'];
    creator = json['creator'];
    collectionName = json['collection_name'];
    tokenName = json['token_name'];
    propertyVersion = json['property_version'];
    collectionId = json['collection_id'];
    collectionSlug = json['collection_slug'];
    seller = json['seller'];
    tokenUri = json['token_uri'];
    previewUri = json['preview_uri'];
    isListed = json['is_listed'];
    price = json['price'];
    highestBid = json['highest_bid'];
    //metadatas = json['metadatas'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token_id'] = this.tokenId;
    data['owner'] = this.owner;
    data['creator'] = this.creator;
    data['collection_name'] = this.collectionName;
    data['token_name'] = this.tokenName;
    data['property_version'] = this.propertyVersion;
    data['collection_id'] = this.collectionId;
    data['collection_slug'] = this.collectionSlug;
    data['seller'] = this.seller;
    data['token_uri'] = this.tokenUri;
    data['preview_uri'] = this.previewUri;
    data['is_listed'] = this.isListed;
    data['price'] = this.price;
    data['highest_bid'] = this.highestBid;
    //   data['metadatas'] = this.metadatas;
    return data;
  }
}
