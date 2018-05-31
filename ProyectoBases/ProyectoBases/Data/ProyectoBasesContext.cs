using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using ProyectoBases.Models;

namespace ProyectoBases.Models
{
    public class ProyectoBasesContext : DbContext
    {
        public ProyectoBasesContext (DbContextOptions<ProyectoBasesContext> options)
            : base(options)
        {
        }


        public DbSet<ProyectoBases.Models.Estudiante> Estudiante { get; set; }


        public DbSet<ProyectoBases.Models.Profesor> Profesor { get; set; }


        public DbSet<ProyectoBases.Models.Grupo> Grupo { get; set; }


        public DbSet<ProyectoBases.Models.ConsumoAgua> ConsumoAgua { get; set; }


        public DbSet<ProyectoBases.Models.AbonadoXPropiedad> AbonadoXPropiedad { get; set; }


        public DbSet<ProyectoBases.Models.EstadoEstudiante> EstadoEstudiante { get; set; }


        public DbSet<ProyectoBases.Models.Municipalidad> Municipalidad { get; set; }


        public DbSet<ProyectoBases.Models.MunicipalidadXPropiedad> MunicipalidadXPropiedad { get; set; }


        public DbSet<ProyectoBases.Models.Propiedad> Propiedad { get; set; }


        public DbSet<ProyectoBases.Models.Recibo> Recibo { get; set; }


        public DbSet<ProyectoBases.Models.ServicioXPropiedad> ServicioXPropiedad { get; set; }


        public DbSet<ProyectoBases.Models.TipoServicio> TipoServicio { get; set; }


        public DbSet<ProyectoBases.Models.Telefono> Telefono { get; set; }


        public DbSet<ProyectoBases.Models.Linea> Linea { get; set; }


        public DbSet<ProyectoBases.Models.InformacionContacto> InformacionContacto { get; set; }


        public DbSet<ProyectoBases.Models.Abonado> Abonado { get; set; }

    }
}
