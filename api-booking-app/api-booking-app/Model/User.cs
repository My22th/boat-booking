using Booking_App_WebApi.Model;
using Microsoft.IdentityModel.Tokens;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Text;

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
        public Suplier? Suplier { get; set; }

    }
    public class Suplier
    {
        [BsonId]
        public ObjectId _Id { get; set; }
        public string Id { get; set; }
        public int UserId { get; set; }
        public List<int> CateId { get; set; }
        public List <int> OrderId { get; set; }
        public string Companyname { get; set; }
        public string Logo { get; set; }
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
