using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace Booking_App_WebApi.Model
{
    [Serializable]
    [BsonIgnoreExtraElements]
    public class Order
    {
        [BsonId]
        public ObjectId _Id { get; set; }
        public int OrderId { get; set; }
        public int BoatId { get; set; }
        public int Userid { get; set; }
        public DateTime BookingDate { get; set; }
        public int DurationInHours { get; set; }
        public decimal TotalPrice { get; set; }
        public string CustomerName { get; set; }
        public string CustomerEmail { get; set; }
        public string ShipDestinitaion { get; set; }    
        
    }
}
