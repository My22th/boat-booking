using Booking_App_WebApi.Model;
using Booking_App_WebApi.Model.MongoDBFD;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Bson;
using MongoDB.Driver;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace Booking_App_WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductsController : ControllerBase
    {
        private readonly int PAGE_SIZE = 10;
        private readonly BookingService _booksService;

        public ProductsController(IConfiguration config, BookingService booksService)
        {
            _booksService = booksService;
        }

        // GET: api/<ProductsController>
        
        [HttpGet]
        public IEnumerable<Product> Get(string key = "", int sortPrice = 0, int page = 0, int pageSize = 10)
        {
            var sortqr = Builders<Product>.Sort.Ascending(x => true);
            switch (sortPrice)
            {
                case 0:
                    break;
                case 1:
                    sortqr.Ascending(x => x.PricePerHour);
                    break;
                case 2:
                    sortqr.Descending(x => x.PricePerHour);
                    break;
                default:
                    break;
            }
            var options = new FindOptions<Product>()
            {
                Limit = pageSize,
                Skip = pageSize,
                Sort = sortqr
            };

            var product = _booksService._productsCollection.Find(x => x.Name.Contains(key)).ToList();
            return product;
            
        }


    }
}
