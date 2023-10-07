using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace api_booking_app.Model
{
    [Serializable]
    [BsonIgnoreExtraElements]
    public class Category
    {
        [BsonId]
        [BsonIgnoreIfDefault]
        public ObjectId _Id { get; set; }
        public int CategoryId { get; set; } 
        public string Name { get; set; }    
        public double CategoryPrice { get; set; }
        public double CategoryVolume { get; set; }
        public string Lat { get; set; }
        public string Long { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public List<string>? LstImgURL { get; set; }
        public BoatType? Type { get; set; }
        public int Capacity { get; set; }
        public decimal PricePerDay { get; set; }
        public int SuplierId { get; set; }
        public List<int> RelatedCate { get; set; }
    }
    public class BoatType
    {
        [BsonId]
        [BsonIgnoreIfDefault]
        public ObjectId _Id { get; set; }
        public int Id { get; set; } 
        public string Name { get; set; }
    }
}
