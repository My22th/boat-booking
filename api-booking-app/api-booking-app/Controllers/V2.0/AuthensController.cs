using FirebaseAdmin.Auth;
using FirebaseAdmin;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Text.Json;
using Newtonsoft.Json;
using System.Text.Json.Serialization;

namespace api_booking_app.Controllers.V2._0
{
    [Route("api/v{version:apiVersion}/[controller]")]
    [ApiController]
    [ApiVersion("2.0")]

    [ApiExplorerSettings(GroupName = "V2")]
    public class AuthensController : ControllerBase
    {
        private IConfiguration _config;

        public AuthensController(IConfiguration config)
        {
            _config = config;
        }



        [HttpPost]
        public async Task<ActionResult> GenerateJSONWebTokenAsync([FromBody] string _token)
        {
           
            var customToken = FirebaseApp.DefaultInstance;
          var dataget = await FirebaseAuth.GetAuth(customToken).VerifyIdTokenAsync(_token[0].ToString());
            string uid = dataget.Uid;

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
