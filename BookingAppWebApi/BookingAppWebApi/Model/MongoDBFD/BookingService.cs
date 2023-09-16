using Booking_App_WebApi.Model;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Driver;

namespace Booking_App_WebApi.Model.MongoDBFD
{
    public class BookingService
    {
        public IConfiguration _config;
        public readonly IMongoCollection<User> _usersCollection;
        public readonly IMongoCollection<Product> _productsCollection;
        //public readonly IMongoCollection<OrderModel> _ordersCollection;
        //public readonly IMongoCollection<HistoryModel> _historysCollection;
        //public readonly IRabitMQProducer _rabitMQProducer;
        public BookingService(IConfiguration config)
        {
            _config = config;
            var client = new MongoClient(_config["BookingMgDatabase:ConnectionString"]);
            var database = client.GetDatabase(_config["BookingMgDatabase:DatabaseName"]);
            _usersCollection = database.GetCollection<User>(_config["BookingMgDatabase:UserCollectionName"]);
            _productsCollection = database.GetCollection<Product>(_config["BookingMgDatabase:ProductsCollectionName"]);
            //_ordersCollection = database.GetCollection<OrderModel>(_config["ImageMgDatabase:OrderCollectionName"]);
            //_historysCollection = database.GetCollection<HistoryModel>(_config["ImageMgDatabase:HistoryCollectionName"]);

            //_rabitMQProducer = rabitMQProducer;
           
        }

    }
}
