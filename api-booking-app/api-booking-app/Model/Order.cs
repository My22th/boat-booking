using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace Booking_App_WebApi.Model
{
    [Serializable]
    [BsonIgnoreExtraElements]
    public class Order
    {
        [BsonId]
        [BsonIgnoreIfDefault]
        public ObjectId _Id { get; set; }
        public int OrderId { get; set; }
        public int BoatId { get; set; }
        public int Userid { get; set; }
        public DateTime BookingDate { get; set; }

        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public int DurationInHours { get; set; }
        public decimal Price { get; set; }
        public string CustomerName { get; set; }
        public string CustomerEmail { get; set; }
        public string ShipDestinitaion { get; set; }
        public int SuplierId { get; set; }
        public double Stats { get; set; }
        public List<Payment> Payment { get; set; }
        public FeedBack FeedBack { get; set; }

    }
    public class FeedBack
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
    public class Payment
    {
        [BsonId]
        [BsonIgnoreIfDefault]
        public ObjectId _Id { get; set; }
        public int Id { get; set; }
        public int Allowedstatus { get; set; }
        public double Price { get; set; }
    }
    public class PaymentType
    {
        [BsonId]
        [BsonIgnoreIfDefault]
        public ObjectId _Id { get; set; }
        public int Id { get; set; }
        public string Paymentname { get; set; }
        public int Status { get; set; }
    }
}
