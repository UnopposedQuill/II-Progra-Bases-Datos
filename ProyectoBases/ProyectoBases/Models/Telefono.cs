﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace ProyectoBases.Models
{
    public class Telefono
    {
        [Key]
        public int Id { get; set; }
        public string telefono { get; set; }
    }
}
