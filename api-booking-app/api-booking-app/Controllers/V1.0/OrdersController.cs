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
        public bool Booking([FromBody] List<BookingRequest> value)
        {
            _bookingService._ordersCollection.InsertOne(new Order()
            {
                FromDate = value.FirstOrDefault().Fromdate,
                ToDate = value.FirstOrDefault().Todate,
                
            });
            return true;
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
