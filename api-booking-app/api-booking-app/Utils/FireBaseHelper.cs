using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using Microsoft.AspNetCore.Builder.Extensions;

namespace api_booking_app.Utils
{
    public class FireBaseHelper
    {
        public void initFireBase()
        {
            if (FirebaseApp.GetInstance("boatbooking-a2b5e") == null)
            {
                FirebaseApp.Create(new AppOptions()
                {
                    Credential = GoogleCredential.GetApplicationDefault(),
                    ProjectId = "708740677078-js4feq6clq5lql2rtleod186goo7ihic.apps.googleusercontent.com",
                });

            }
                
        }
    }
}
