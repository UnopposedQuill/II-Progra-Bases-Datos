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
    [Route("api/Propiedad")]
    public class PropiedadController : Controller
    {
        private readonly ProyectoBasesContext _context;

        public PropiedadController(ProyectoBasesContext context)
        {
            _context = context;
        }

        // GET: api/Propiedad
        [HttpGet]
        public IEnumerable<Propiedad> GetPropiedad()
        {
            return _context.Propiedad;
        }

        // GET: api/Propiedad/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetPropiedad([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var propiedad = await _context.Propiedad.SingleOrDefaultAsync(m => m.Id == id);

            if (propiedad == null)
            {
                return NotFound();
            }

            return Ok(propiedad);
        }

        // PUT: api/Propiedad/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutPropiedad([FromRoute] int id, [FromBody] Propiedad propiedad)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != propiedad.Id)
            {
                return BadRequest();
            }

            _context.Entry(propiedad).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!PropiedadExists(id))
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

        // POST: api/Propiedad
        [HttpPost]
        public async Task<IActionResult> PostPropiedad([FromBody] Propiedad propiedad)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            _context.Propiedad.Add(propiedad);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetPropiedad", new { id = propiedad.Id }, propiedad);
        }

        // DELETE: api/Propiedad/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePropiedad([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var propiedad = await _context.Propiedad.SingleOrDefaultAsync(m => m.Id == id);
            if (propiedad == null)
            {
                return NotFound();
            }

            _context.Propiedad.Remove(propiedad);
            await _context.SaveChangesAsync();

            return Ok(propiedad);
        }

        private bool PropiedadExists(int id)
        {
            return _context.Propiedad.Any(e => e.Id == id);
        }
    }
}