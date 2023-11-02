using api_booking_app.Model;
using api_booking_app.Utils;
using Booking_App_WebApi.Controllers;
using Booking_App_WebApi.Model;
using Booking_App_WebApi.Model.MongoDBFD;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Driver;
using NuGet.Packaging;

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

        private IConfiguration _config;

       
        public OrdersController(BookingService bookingService, IConfiguration configuration)
        {
            _bookingService = bookingService;
            _config = configuration;
        }
        // GET: api/<OrdersController>
        [HttpGet]
        public ActionResult FindOrders()
        {
            var token = Request.Headers["Authorization"].ToString();
            var user = new BaseClass(_config).GetUserValid(token);
            if (string.IsNullOrEmpty(user.UserEmail))
            {
                return new JsonResult(new
                {
                    code = 400,
                    msg = "Not Authen"
                });
            }
            
            return new JsonResult(new
            {
                code = 200,
                msg = _bookingService._ordersCollection.Find(x => x.CustomerEmail == user.UserEmail).ToList()
            });
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
            var token = Request.Headers["Authorization"].ToString();
            var user = new BaseClass(_config).GetUserValid(token);
            if (string.IsNullOrEmpty(user.UserEmail))
            {
                return new JsonResult(new
                {
                    code = 400,
                    msg = "Not Authen"
                });
            }
            bool isError = false;
            string message = string.Empty;
            var lstTemp = new List<Order>();
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
               
                var lstorder = _bookingService._ordersCollection.FindAsync(filter).Result.ToList().Concat(lstTemp);
                var lstexclude = lstorder.Select(x => x.BoatId).ToArray();
                var resultPRodcut = _bookingService._catesCollection.Aggregate()
                    .Lookup<Category, Product, LookedUpCate>(_bookingService._productsCollection,
                        x => x.CategoryId,
                        y => y.CategoryId,
                        y => y.InnerProducts
                ).ToList().Where(x => x.CategoryId == item.CategoryId && x.InnerProducts.Any()).FirstOrDefault();
                var lstgetpd= resultPRodcut?.InnerProducts?.Where(x => !lstexclude.Contains(x.BoatId)).ToList();
                if (lstgetpd == null || lstgetpd.Count() == 0)
                {
                    isError = true;
                    message = "Item " + item.CategoryId + " Out of stock";
                    break;
                }
                if(lstgetpd.Count>0)
                lstTemp.Add(new Order
                {
                    BoatId = lstgetpd.First().BoatId,
                    FromDate = item.Fromdate,
                    ToDate = item.Todate,
                    BookingDate = DateTime.Now,
                    CustomerEmail = user.UserEmail,
                    CustomerName = user.UserName,
                    Price = lstgetpd.First().PricePerHour,
                    
                });

            }
            if (isError)
            {
                return new JsonResult(new
                {
                    code = 400,
                    msg = message
                });
            }
            else
            {
              var data =  _bookingService._ordersCollection.InsertManyAsync(lstTemp);
                return new JsonResult(new
                {
                    code = 200,
                    msg = "Order Success"
                });
            }
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
