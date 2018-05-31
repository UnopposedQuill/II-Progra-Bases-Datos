using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ProyectoBases.Models;

namespace ProyectoBases.Controllers
{
    [Produces("application/json")]
    [Route("api/ServicioXPropiedad")]
    public class ServicioXPropiedadController : Controller
    {
        private readonly ProyectoBasesContext _context;

        public ServicioXPropiedadController(ProyectoBasesContext context)
        {
            _context = context;
        }

        // GET: api/ServicioXPropiedad
        [HttpGet]
        public IEnumerable<ServicioXPropiedad> GetServicioXPropiedad()
        {
            return _context.ServicioXPropiedad;
        }

        // GET: api/ServicioXPropiedad/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetServicioXPropiedad([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var servicioXPropiedad = await _context.ServicioXPropiedad.SingleOrDefaultAsync(m => m.Id == id);

            if (servicioXPropiedad == null)
            {
                return NotFound();
            }

            return Ok(servicioXPropiedad);
        }

        // PUT: api/ServicioXPropiedad/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutServicioXPropiedad([FromRoute] int id, [FromBody] ServicioXPropiedad servicioXPropiedad)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != servicioXPropiedad.Id)
            {
                return BadRequest();
            }

            _context.Entry(servicioXPropiedad).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ServicioXPropiedadExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/ServicioXPropiedad
        [HttpPost]
        public async Task<IActionResult> PostServicioXPropiedad([FromBody] ServicioXPropiedad servicioXPropiedad)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            _context.ServicioXPropiedad.Add(servicioXPropiedad);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetServicioXPropiedad", new { id = servicioXPropiedad.Id }, servicioXPropiedad);
        }

        // DELETE: api/ServicioXPropiedad/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteServicioXPropiedad([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var servicioXPropiedad = await _context.ServicioXPropiedad.SingleOrDefaultAsync(m => m.Id == id);
            if (servicioXPropiedad == null)
            {
                return NotFound();
            }

            _context.ServicioXPropiedad.Remove(servicioXPropiedad);
            await _context.SaveChangesAsync();

            return Ok(servicioXPropiedad);
        }

        private bool ServicioXPropiedadExists(int id)
        {
            return _context.ServicioXPropiedad.Any(e => e.Id == id);
        }
    }
}