using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using System;

namespace Booking_App_WebApi.Model
{
    public class User
    {
        [BsonId]
        public ObjectId _Id { get; set; }
        public string Id { get; set; }
        public string UserName { get; set; }
        public string UserEmail { get; set; }
        public string Age { get; set; }
        public DateTime Created { get; set; }   
        public DateTime Updated { get; set; }
        public int IsActive { get; set; }   
        public string Notes { get; set; }
        public string OrderID { get; set; }
        public string TokenID { get; set; }
        public List<string> Address { get; set; }
        public string Phone { get; set; }

        public RoleUser Role { get; set; }

    }
    public enum RoleUser
    {
        None,
        Unknows,
        User,
        Admin,
        Manager
    }
}
