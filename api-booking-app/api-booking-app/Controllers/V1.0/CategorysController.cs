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
