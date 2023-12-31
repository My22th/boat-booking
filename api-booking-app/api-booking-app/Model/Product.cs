﻿using MongoDB.Bson.Serialization.Attributes;
using MongoDB.Bson;

namespace Booking_App_WebApi.Model
{
    [Serializable]
    [BsonIgnoreExtraElements]

    public class Product
    {
        [BsonId]
        [BsonIgnoreIfDefault]
        public ObjectId _Id { get; set; }
        public int BoatId { get; set; }
        public int CategoryId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public int Capacity { get; set; }
        public decimal PricePerHour { get; set; }
        public string Location { get; set; }
        public List<string> Amenities { get; set; }
        public List<string>? LstImgURL { get; set; }
        public string ManagerId { get; set; }
        public string ManagerName { get; set; }
        public string ManagerContact { get; set; }
        public string ImageUrl { get; set; }
        public string EngineType { get; set; }
        public double Length { get; set; }
        public string Manufacturer { get; set; }
        public int YearOfManufacture { get; set; }
        public string RegistrationNumber { get; set; }
        public string InsuranceProvider { get; set; }
        public DateTime InsuranceExpiry { get; set; }
        public List<string> SafetyEquipment { get; set; }
        public List<Reviews> Reviews { get; set; }
    }
    public class Reviews
    {
        [BsonId]
        [BsonIgnoreIfDefault]
        public ObjectId _Id { get; set; }
        public int Id { get; set; }
        public string Notes { get; set; }
        public double Rating { get; set; }
        public DateTime PublishDate { get; set; }
        public int Active { get; set; }
    }
}
