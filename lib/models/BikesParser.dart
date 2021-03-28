class BikesParser {
  String id,
      bike_id,
      title,
      description,
      base_fare,
      cost_per_minute,
      cost_per_km,
      image_link,
      lat,
      lang,
      status,
      created_at;

  BikesParser(
      {this.id,
      this.bike_id,
      this.title,
      this.description,
      this.base_fare,
      this.cost_per_minute,
      this.cost_per_km,
      this.image_link,
      this.lat,
      this.lang,
      this.status,
      this.created_at});

  factory BikesParser.fromJson(Map<String, dynamic> json) => BikesParser(
        id: json["id"],
        bike_id: json["bike_id"],
        title: json["title"],
        description: json["description"],
        base_fare: json["base_fare"],
        cost_per_minute: json["cost_per_minute"],
        cost_per_km: json["cost_per_km"],
        image_link: json["image_link"],
        lat: json["lat"],
        lang: json["lang"],
        status: json["status"],
        created_at: json["created_at"],
      );
}
