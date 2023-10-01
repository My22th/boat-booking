
using api_booking_app.Controllers.V1._0;
using Booking_App_WebApi.Controllers;
using Booking_App_WebApi.Model.MongoDBFD;
using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using In_Anh.RabitMQ;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Mvc.Versioning;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using MongoDB.Driver;
using System.Text;
using static Lucene.Net.Index.SegmentReader;
using static System.Net.Mime.MediaTypeNames;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme).AddJwtBearer(options =>
{
    options.RequireHttpsMetadata = false;
    options.SaveToken = true;
    options.TokenValidationParameters = new TokenValidationParameters()
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidAudience = builder.Configuration["Jwt:Audience"],
        ValidIssuer = builder.Configuration["Jwt:Issuer"],
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"]))
    };
});
if (FirebaseApp.DefaultInstance == null)
{
    Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", ".\\service-account-file.json");
    FirebaseApp.Create(new AppOptions()
    {
        Credential = GoogleCredential.GetApplicationDefault(),
        ProjectId = "boatbooking-a2b5e",
    });
}
builder.Services.AddSingleton<IBoatBookingMgDatabase>(provider =>
    provider.GetRequiredService<IOptions<BoatBookingMgDatabase>>().Value);
builder.Services.Configure<IBoatBookingMgDatabase>(
    builder.Configuration.GetSection("ImageMgDatabase"));
builder.Services.AddScoped<IBoatBookingMgDatabase, BoatBookingMgDatabase>();
builder.Services.AddHostedService<RabitMQConsumer>();
builder.Services.AddScoped<IRabitMQProducer, RabitMQProducer>();
builder.Services.AddRouting(options => options.LowercaseUrls = true);

builder.Services.AddSingleton<BookingService>();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("V1", new OpenApiInfo() { Title = "API V1", Version = "V1.0" });
    c.SwaggerDoc("V2", new OpenApiInfo() { Title = "API V2", Version = "V2.0" });
    c.ResolveConflictingActions(apiDescriptions => apiDescriptions.First());
    c.CustomSchemaIds(x => x.FullName);
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        In = ParameterLocation.Header,
        Description = "Please insert JWT with Bearer into field",
        Name = "Authorization",
        Type = SecuritySchemeType.ApiKey
    });
    c.AddSecurityRequirement(new OpenApiSecurityRequirement {
   {
     new OpenApiSecurityScheme
     {
       Reference = new OpenApiReference
       {
         Type = ReferenceType.SecurityScheme,
         Id = "Bearer"
       }
      },
      new string[] { }
    }
  });
});
//builder.Services.AddMvc();
builder.Services.AddMvc(option => option.EnableEndpointRouting = false);
builder.Services.AddApiVersioning(
  options =>
  {
      options.ReportApiVersions = true;

      options.Conventions.Controller<ProductsController>().HasApiVersion(new Microsoft.AspNetCore.Mvc.ApiVersion(1, 0));
      options.Conventions.Controller<api_booking_app.Controllers.ProductsController>().HasApiVersion(new Microsoft.AspNetCore.Mvc.ApiVersion(2, 0));

      options.Conventions.Controller<AuthensController>().HasApiVersion(new Microsoft.AspNetCore.Mvc.ApiVersion(1, 0));
      options.Conventions.Controller<api_booking_app.Controllers.V2._0.AuthensController>().HasApiVersion(new Microsoft.AspNetCore.Mvc.ApiVersion(2, 0));
      options.Conventions.Controller<OrdersController>().HasApiVersion(new Microsoft.AspNetCore.Mvc.ApiVersion(1, 0));
      //options.Conventions.Controller<api_booking_app.Controllers.V2._0.AuthensController>().HasApiVersion(new Microsoft.AspNetCore.Mvc.ApiVersion(2, 0));
      //options.AssumeDefaultVersionWhenUnspecified = true;
      //options.UseApiBehavior = false;
      options.ApiVersionReader = new UrlSegmentApiVersionReader();
  }
).AddVersionedApiExplorer(o =>
{
    o.GroupNameFormat = "'v'VVV";
    o.SubstituteApiVersionInUrl = true;
});
var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment() || app.Environment.IsProduction())
{
    app.UseSwagger();
    app.UseSwaggerUI(options =>
    {
        options.SwaggerEndpoint($"/swagger/V1/swagger.json", "V1.0");
        options.SwaggerEndpoint($"/swagger/V2/swagger.json", "V2.0");
    }
  );
}

app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();
app.UseCors("AllPolicy");
app.MapControllers();
app.Use(async (context, next) =>
{
    context.Response.Headers.Add("Access-Control-Allow-Origin", "*");
    context.Response.Headers.Add("Access-Control-Allow-Methods", "GET,PUT,PATCH,POST,DELETE");
    context.Response.Headers.Add("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    await next.Invoke();
});
app.Run();
