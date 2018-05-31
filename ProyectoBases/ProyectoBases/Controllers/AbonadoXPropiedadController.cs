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
    [Route("api/AbonadoXPropiedad")]
    public class AbonadoXPropiedadController : Controller
    {
        private readonly ProyectoBasesContext _context;

        public AbonadoXPropiedadController(ProyectoBasesContext context)
        {
            _context = context;
        }

        // GET: api/AbonadoXPropiedad
        [HttpGet]
        public IEnumerable<AbonadoXPropiedad> GetAbonadoXPropiedad()
        {
            return _context.AbonadoXPropiedad;
        }

        // GET: api/AbonadoXPropiedad/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetAbonadoXPropiedad([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var abonadoXPropiedad = await _context.AbonadoXPropiedad.SingleOrDefaultAsync(m => m.Id == id);

            if (abonadoXPropiedad == null)
            {
                return NotFound();
            }

            return Ok(abonadoXPropiedad);
        }

        // PUT: api/AbonadoXPropiedad/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutAbonadoXPropiedad([FromRoute] int id, [FromBody] AbonadoXPropiedad abonadoXPropiedad)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != abonadoXPropiedad.Id)
            {
                return BadRequest();
            }

            _context.Entry(abonadoXPropiedad).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!AbonadoXPropiedadExists(id))
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

        // POST: api/AbonadoXPropiedad
        [HttpPost]
        public async Task<IActionResult> PostAbonadoXPropiedad([FromBody] AbonadoXPropiedad abonadoXPropiedad)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            _context.AbonadoXPropiedad.Add(abonadoXPropiedad);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetAbonadoXPropiedad", new { id = abonadoXPropiedad.Id }, abonadoXPropiedad);
        }

        // DELETE: api/AbonadoXPropiedad/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAbonadoXPropiedad([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var abonadoXPropiedad = await _context.AbonadoXPropiedad.SingleOrDefaultAsync(m => m.Id == id);
            if (abonadoXPropiedad == null)
            {
                return NotFound();
            }

            _context.AbonadoXPropiedad.Remove(abonadoXPropiedad);
            await _context.SaveChangesAsync();

            return Ok(abonadoXPropiedad);
        }

        private bool AbonadoXPropiedadExists(int id)
        {
            return _context.AbonadoXPropiedad.Any(e => e.Id == id);
        }
    }
}