using Booking_App_WebApi.Model;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Text;

namespace api_booking_app.Utils
{
    public class BaseClass
    {
        private IConfiguration _config;

        public BaseClass()
        {

        }
        public BaseClass(IConfiguration config)
        {
            _config = config;
        }
        public User GetUserValid(string token )
        {

            var user = new User();
            var mySecret = Encoding.UTF8.GetBytes(_config["Jwt:Key"]);
            var mySecurityKey = new SymmetricSecurityKey(mySecret);
            var tokenHandler = new JwtSecurityTokenHandler();
            try
            {
                tokenHandler.ValidateToken(token,
                new TokenValidationParameters
                {
                    ValidateIssuerSigningKey = true,
                    
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidIssuer = _config["Jwt:Issuer"],
                    ValidAudience = _config["Jwt:Audience"],
                    IssuerSigningKey = mySecurityKey,
                }, out SecurityToken validatedToken);

                var tokenS = tokenHandler?.ReadToken(token) as JwtSecurityToken;
                user.Id = tokenS?.Claims?.First(claim => claim.Type == "UserId")?.Value;
                user.UserEmail = tokenS?.Claims?.First(claim => claim.Type == "Email")?.Value;
                user.UserName = tokenS?.Claims?.First(claim => claim.Type == "DisplayName")?.Value;
                user.Phone = tokenS?.Claims?.First(claim => claim.Type == "Phone")?.Value;

            }
            catch
            {
                return new User();
            }
            return user;
        }
    }
}
