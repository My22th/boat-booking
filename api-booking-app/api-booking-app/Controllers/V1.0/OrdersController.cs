using api_booking_app.Model;
using Booking_App_WebApi.Model;
using Booking_App_WebApi.Model.MongoDBFD;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Driver;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace api_booking_app.Controllers.V1._0
{
    [Route("api/v{version:apiVersion}/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]

    [ApiExplorerSettings(GroupName = "V1")]
    public class OrdersController : ControllerBase
    {
        private readonly BookingService _bookingService;
        public OrdersController(BookingService bookingService)
        {
            _bookingService = bookingService;
        }
        // GET: api/<OrdersController>
        [HttpGet]
        public List<Order> FindOrders(int userId)
        {
            return _bookingService._ordersCollection.Find(x => x.Userid == userId).ToList();
        }

        // GET api/<OrdersController>/5
        [HttpGet("{id}")]
        public Order Get(int id)
        {
            return _bookingService._ordersCollection.Find(x => x.OrderId == id).FirstOrDefault();
        }

        // POST api/<OrdersController>
        [HttpPost("Booking")]
        public ActionResult Booking([FromBody] List<BookingRequest> value)
        {
            var token = Request.Headers["XYZComponent"].ToString();

            bool isError = false;
            string message = string.Empty;

            foreach (var item in value)
            {
                if (item.Fromdate < DateTime.Now)
                {
                    isError = true;
                    message = "Cannot detect date of item " + item.CategoryId;
                    break;

                }
                if (item.Todate < DateTime.Now)
                {
                    isError = true;
                    message = "Cannot detect date of item " + item.CategoryId;
                    break;
                }
                var filter = Builders<Order>.Filter.Gte(x => x.FromDate, item.Fromdate);
                filter &= Builders<Order>.Filter.Lte(x => x.ToDate, item.Todate);
                var lstorder = _bookingService._ordersCollection.FindAsync(filter).Result.ToList();
                var lstexclude = lstorder.Select(x => x.BoatId).ToArray();
                var resultPRodcut = _bookingService._catesCollection.Aggregate()
                    .Lookup<Category, Product, LookedUpCate>(_bookingService._productsCollection,
                        x => x.CategoryId,
                        y => y.CategoryId,
                        y => y.InnerProducts
                ).ToList().Where(x => x.InnerProducts.Any() && !x.InnerProducts.Select(y => y.BoatId).ToArray().Intersect(lstexclude).Any()).FirstOrDefault();
                if (resultPRodcut == null || resultPRodcut.InnerProducts.Count()==0)
                {
                    isError = true;
                    message = "Item "+item.CategoryId+" Out of stock";
                    break;
                }
                //_bookingService._ordersCollection.
                

            }

        
            return new JsonResult(new
            {
                code = 200,
                msg=""
            });
        }


[HttpPost]
public bool Post([FromBody] Order value)
{
    _bookingService._ordersCollection.InsertOne(value);
    return true;
}

// PUT api/<OrdersController>/5
[HttpPut("{id}")]
public void Put(int id, [FromBody] string value)
{
}

// DELETE api/<OrdersController>/5
[HttpDelete("{id}")]
public void Delete(int id)
{
}
    }
}
