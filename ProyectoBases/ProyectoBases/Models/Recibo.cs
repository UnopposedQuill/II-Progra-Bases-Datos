using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace ProyectoBases.Models
{
    public class Recibo
    {
        [Key]
        public int Id { get; set; }
        public DateTime FechaEmision { get; set; }
        public float TotalAPagarSinIntereses { get; set; }
        public float InteresesMoratorios { get; set; }
        public float TotalPagado { get; set; }
        public DateTime FechaLimite { get; set; }
        public DateTime FechaPagado { get; set; }
        public bool Habilitado { get; set; }

    }
}
