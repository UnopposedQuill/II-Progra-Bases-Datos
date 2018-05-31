using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace ProyectoBases.Models
{
    public class InformacionContacto
    {
        [Key]
        public int Id { get; set; }
        public string Correo { get; set; }
        public string Direccion { get; set; }
    }
}
