using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace ProyectoBases.Models
{
    public class TipoServicio
    {
        [Key]
        public int Id { get; set; }
        public string Nombre { get; set; }
        public float Valor { get; set; }
        public bool Habilitado { get; set; }
    }
}
