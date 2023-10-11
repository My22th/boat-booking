using api_booking_app.Model;
using Booking_App_WebApi.Model;
using Booking_App_WebApi.Model.MongoDBFD;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Bson;
using MongoDB.Bson.IO;
using MongoDB.Driver;
using Newtonsoft.Json;
using System.Text.Json.Serialization;
using static System.Reflection.Metadata.BlobBuilder;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace api_booking_app.Controllers.V1._0
{
    [Route("api/v{version:apiVersion}/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]

    [ApiExplorerSettings(GroupName = "V1")]
    public class CategorysController : ControllerBase
    {
        private readonly BookingService _bookingService;
        public CategorysController(BookingService bookingService)
        {
            _bookingService = bookingService;
        }
        // GET: api/<CategorysController>
        [HttpGet]
        public IEnumerable<Category> Get()
        {
            return _bookingService._catesCollection.FindAsync(x => true, null).Result.ToEnumerable();
        }

        // GET api/<CategorysController>/5
        [HttpGet("{id}")]
        public Category Get(int id)
        {
            return _bookingService._catesCollection.FindAsync(x => true, null).Result.FirstOrDefault();
        }
        [HttpGet("getbydate")]
        public ActionResult Get(DateTime? fromdate, DateTime? todate)
        {
            //if (fromdate == null || todate == null)
            //{
            //    return new JsonResult(new
            //    {
            //        code = 400,
            //        msg = "Cannot detect date"
            //    });
            //}
            //if (fromdate > DateTime.Now || todate > DateTime.Now)
            //{
            //    return new JsonResult(new
            //    {
            //        code = 400,
            //        msg = "Cannot detect date"
            //    });
            //}
            var filter = Builders<Order>.Filter.Gte(x => x.FromDate, fromdate);
            filter &= Builders<Order>.Filter.Lte(x => x.ToDate, todate);
            var lstorder = _bookingService._ordersCollection.FindAsync(filter).Result.ToList();
            var lstexclude = lstorder.Select(x=>x.BoatId).ToArray();
            var resultPRodcut = _bookingService._catesCollection.Aggregate()
                .Lookup<Category, Product, LookedUpCate>(_bookingService._productsCollection,
                    x => x.CategoryId,
                    y => y.CategoryId,
                    y=>y.InnerProducts
            ).ToList().Where(x=>x.InnerProducts.Any()&& !x.InnerProducts.Select(y=>y.BoatId).ToArray().Intersect(lstexclude).Any()).ToList();
            return new JsonResult(new
            {
                code = 200,
                msg = Newtonsoft.Json.JsonConvert.SerializeObject(resultPRodcut)
            }); 
            //return _bookingService._catesCollection.FindAsync(x => true, null).Result.FirstOrDefault();
        }
        // POST api/<CategorysController>
        [HttpPost]
        public bool Post([FromBody] Category value)
        {
            if (_bookingService._catesCollection.Find(x => x.CategoryId.Equals(value.CategoryId)).FirstOrDefault() != null)
            {
                return false;
            }
            _bookingService._catesCollection.InsertOne(value);
            return true;
        }

        // PUT api/<CategorysController>/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE api/<CategorysController>/5
        [HttpDelete("{id}")]
        public void Delete(int id)
        {
        }
    }
}
