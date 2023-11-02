using FirebaseAdmin.Auth;
using FirebaseAdmin;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Booking_App_WebApi.Model;
using api_booking_app.Model;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace Booking_App_WebApi.Controllers
{
    [Route("api/v{version:apiVersion}/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]

    [ApiExplorerSettings(GroupName = "V1")]
    public class AuthensController : ControllerBase
    {
        private IConfiguration _config;

        public AuthensController(IConfiguration config)
        {
            _config = config;
        }



        [HttpPost]
        public async Task<ActionResult> GenerateJSONWebTokenAsync([FromBody] TokenAuthenRequest _token)
        {

            var customToken = FirebaseApp.DefaultInstance;
            var dataget =  FirebaseAuth.GetAuth(customToken).VerifyIdTokenAsync(_token.Token.ToString());
            string uid = dataget.Result.Uid;

            var user = await FirebaseAuth.GetAuth(customToken).GetUserAsync(uid);
            var claims = new[] {
                        new Claim(JwtRegisteredClaimNames.Sub, _config["Jwt:Subject"]),
                        new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                        new Claim(JwtRegisteredClaimNames.Iat, DateTime.UtcNow.ToString()),
                        new Claim("UserId", user.TenantId??""),
                        new Claim("DisplayName", user.DisplayName??""),
                        new Claim("Phone",user.PhoneNumber ?? ""),
                        new Claim("Email", user.Email ?? ""),
                        new Claim("Uid", user.Uid ?? "")
                    };

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["Jwt:Key"]));
            var signIn = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
            var token = new JwtSecurityToken(
                _config["Jwt:Issuer"],
                _config["Jwt:Audience"],
                claims,
                expires: DateTime.UtcNow.AddMinutes(102),
                signingCredentials: signIn);

            return Ok(new JwtSecurityTokenHandler().WriteToken(token));
        }
        

    }

   
}
