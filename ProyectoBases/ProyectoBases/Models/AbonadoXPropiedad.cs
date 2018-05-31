using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace ProyectoBases.Models
{
    public class AbonadoXPropiedad
    {
        [Key]
        public int Id { get; set; }
        public DateTime FechaLectura { get; set; }
        public float ContadorMetrosCUbicos { get; set; }
        public bool Habilitado { get; set; }

    }
}

