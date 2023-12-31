﻿using Booking_App_WebApi.Model.MongoDBFD;
using Booking_App_WebApi.Model;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Driver;

namespace api_booking_app.Controllers
{

    [ApiVersion("2.0")]
    [Route("api/v{version:apiVersion}/[controller]")]
    //[Route("api/v2/product")]
    [ApiController]
    [ApiExplorerSettings(GroupName = "V2")]
    public class ProductsController : ControllerBase
    {
        private readonly int PAGE_SIZE = 10;
        private readonly BookingService _bookingService;

        public ProductsController(IConfiguration config, BookingService bookingService)
        {
            _bookingService = bookingService;
        }

        // GET: api/<ProductsController>

        [HttpGet("{id}")]

        public Product GetByid(int id)
        {
            return _bookingService._productsCollection.Find(x => x.BoatId == id).FirstOrDefault();
        }
        [HttpGet("search")]

        public IEnumerable<Product> Get(string key = "", int sortPrice = 0, int page = 0, int pageSize = 10)
        {
            var sortqr = default(SortDefinition<Product>);
            switch (sortPrice)
            {
                case 0:
                    break;
                case 1:
                    sortqr = Builders<Product>.Sort.Ascending(x => x.PricePerHour);
                    break;
                case 2:
                    sortqr = Builders<Product>.Sort.Descending(x => x.PricePerHour);
                    break;
                default:
                    break;
            }
            var options = new FindOptions<Product>()
            {
                Limit = pageSize,
                Skip = page * pageSize,
                Sort = sortqr
            };

            var product = _bookingService._productsCollection.FindAsync(x => x.Name.Contains(key), options).Result.ToList();
            return product;

        }

        // POST api/<ProductController>
        [HttpPost]
        public bool PostAsync([FromBody] Product product)
        {
            _bookingService._productsCollection.InsertOne(product);
            return true;
        }

        // PUT api/<ProductController>/5
        [HttpPut("{id}")]
        public bool Put(int id, [FromBody] Product product)
        {
            var old = _bookingService._productsCollection.Find(x => x.BoatId == id);
            if (old != null)
            {
                var filter = Builders<Product>.Filter.Eq(x => x.BoatId, id);
                var update = Builders<Product>.Update.Set(x => x, product);
                var isss = _bookingService._productsCollection.UpdateOne(filter, update);
                return isss.MatchedCount > 0;
            }
            return false;
        }

        // DELETE api/<ProductController>/5
        [HttpDelete("{id}")]
        public bool Delete(int id)
        {
            var ft = Builders<Product>.Filter.Eq(x => x.BoatId, id);
            var isss = _bookingService._productsCollection.DeleteOne(ft);
            return isss.DeletedCount > 0;
        }
    }
}
