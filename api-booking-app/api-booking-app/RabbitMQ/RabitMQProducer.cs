using Lucene.Net.Support;

using RabbitMQ.Client;
using System.Drawing.Drawing2D;
using System.Net;
using System.Net.Sockets;
using System.Text;

namespace In_Anh.RabitMQ
{
    public class RabitMQProducer : IRabitMQProducer
    {
        public void SendProductMessage(IConnection connection, IModel channel, byte[] body)
        {

            try
            { 
                var props = new HashMap<string, object>();
                channel.QueueDeclareNoWait(queue: "bookingboat",
                      durable: true,
                      exclusive: false,
                      autoDelete: false,
                      arguments: null);

                channel.BasicPublish(exchange: string.Empty,
                     routingKey: "bookingboat",
                     basicProperties: null,
                     body: body);
            }
            catch (Exception e)
            {
                var a = e.Message;
                throw;
            }
        }
    }
}
