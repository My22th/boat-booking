using Booking_App_WebApi.Model;
using Microsoft.Extensions.Options;
using MongoDB.Driver;

namespace api_booking_app.Model.MongoDBFD
{
    public class DBContext
    {
        
        public interface IMongoBookDBContext
        {
            IMongoCollection<T> GetCollection<T>(string name);
        }
        public class MongoBookDBContext : IMongoBookDBContext
        {
            private readonly IConfiguration _config;
            public readonly IMongoCollection<User> _usersCollection;
            public readonly IMongoCollection<Product> _productsCollection;

            private readonly IMongoDatabase   _database;
            private MongoClient _mongoClient { get; set; }
            public IClientSessionHandle Session { get; set; }
            public MongoBookDBContext(IConfiguration config)
            {
                _config = config;
                _mongoClient = new MongoClient(_config["BookingMgDatabase:ConnectionString"]);
                _database = _mongoClient.GetDatabase(_config["BookingMgDatabase:DatabaseName"]);
            }

            public IMongoCollection<T> GetCollection<T>(string name)
            {
                return _database.GetCollection<T>(name);
            }
        }
    }
}
