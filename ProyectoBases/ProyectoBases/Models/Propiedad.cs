using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace ProyectoBases.Models
{
    public class Propiedad
    {
        [Key]
        public int Id { get; set; }
        public string Descripcion { get; set; }
        public float Valor { get; set; }
        public string CodigoPostal { get; set; }
        public int NumeroFinca { get; set; }
        public bool Habilitado { get; set; }

    }
}
