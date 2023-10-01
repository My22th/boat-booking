using RabbitMQ.Client;
using System.Net.Sockets;
using System.Net;
using Lucene.Net.Support;
using RabbitMQ.Client.Events;
using System.Text;
using Newtonsoft.Json;


namespace In_Anh.RabitMQ
{
    public class RabitMQConsumer : IHostedService
    {

        public IConfiguration _config;

        //public IMongoCollection<OrderModel> _ordersCollection;
        //public IMongoCollection<ImageModel> _imagesCollection;

        public readonly IRabitMQProducer _rabitMQProducer;


        public RabitMQConsumer(IConfiguration config)
        {
            _config = config;


        }
        private IModel channel = null;
        private IConnection connection = null;
        private void Run()
        {
            var factory = new ConnectionFactory()
            {
                HostName = "116.102.20.114",
                VirtualHost = "/",
                UserName = "admin",
                Password = "admin"
            };
            factory.NetworkRecoveryInterval = TimeSpan.FromSeconds(15);
            connection = factory.CreateConnection();
            channel = connection.CreateModel();
            channel.QueueDeclare(queue: "bookingboat",
                                durable: true,
                                exclusive: false,
                                autoDelete: false,
                                arguments: null);
            channel.BasicQos(prefetchSize: 0, prefetchCount: 1, global: false);
            Console.WriteLine(" [*] Waiting for messages.");
            var consumer = new EventingBasicConsumer(this.channel);
            consumer.Received += OnMessageRecieved;
            channel.BasicConsume(queue: "bookingboat",
                                autoAck: false,
                                consumer: consumer);
        }

        public Task StartAsync(CancellationToken cancellationToken)
        {
            Run();
            return Task.CompletedTask;
        }

        public Task StopAsync(CancellationToken cancellationToken)
        {
            channel.Dispose();
            connection.Dispose();
            return Task.CompletedTask;
        }

        private async void OnMessageRecieved(object model, BasicDeliverEventArgs args)
        {
            var body = args.Body.ToArray();
            var message = Encoding.UTF8.GetString(body);
            var data = JsonConvert.DeserializeObject<object>(message);
            //var fileName = data.FileName;
            //var filePath = data.Path + "\\" + fileName;
            //using (var memoryStream = new MemoryStream(data.File))
            //{
            //    string content = Encoding.UTF8.GetString(data.File);
            //    if (Regex.IsMatch(content, @"<script|<cross\-domain\-policy",
            //        RegexOptions.IgnoreCase | RegexOptions.CultureInvariant | RegexOptions.Multiline))
            //    {
            //        return;
            //    }
            //    if (!Directory.Exists(data.Path))
            //    {
            //        Directory.CreateDirectory(data.Path);
            //    }
            //    if (!File.Exists(filePath))
            //    {
            //        using (FileStream f = File.Create(filePath))
            //        {
            //            f.Dispose();
            //        }
            //    }
            //    memoryStream.Position = 0;
            //    using (MagickImage image = new MagickImage(memoryStream))
            //    {
            //        image.Format = MagickFormat.Jpeg;
            //        image.Quality = 100;
            //        image.Write(filePath);
            //        image.Dispose();
            //    }
            //    var issv = await SaveImageAsync(data.OrderID, data.CDNPath + fileName, data.Type);

            //    memoryStream.Close();
            //}
            Console.WriteLine(" [x] Done");
            channel.BasicAck(deliveryTag: args.DeliveryTag, multiple: false);
        }

        
    }
}
