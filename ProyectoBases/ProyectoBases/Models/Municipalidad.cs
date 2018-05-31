using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace ProyectoBases.Models
{
    public class Municipalidad
    {
        [Key]
        public int Id { get; set; }
        public string Nombre { get; set; }
        public DateTime DiaEmision { get; set; }
        public DateTime DiaLimite { get; set; }
        public float InteresesMorosidad { get; set; }
        public float ValorMetroCubicoAgua { get; set; }
        public bool Habilitado { get; set; }


    }

}
