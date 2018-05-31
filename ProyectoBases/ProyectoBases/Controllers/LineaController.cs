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
    [Route("api/Linea")]
    public class LineaController : Controller
    {
        private readonly ProyectoBasesContext _context;

        public LineaController(ProyectoBasesContext context)
        {
            _context = context;
        }

        // GET: api/Linea
        [HttpGet]
        public IEnumerable<Linea> GetLinea()
        {
            return _context.Linea;
        }

        // GET: api/Linea/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetLinea([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var linea = await _context.Linea.SingleOrDefaultAsync(m => m.Id == id);

            if (linea == null)
            {
                return NotFound();
            }

            return Ok(linea);
        }

        // PUT: api/Linea/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutLinea([FromRoute] int id, [FromBody] Linea linea)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != linea.Id)
            {
                return BadRequest();
            }

            _context.Entry(linea).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!LineaExists(id))
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

        // POST: api/Linea
        [HttpPost]
        public async Task<IActionResult> PostLinea([FromBody] Linea linea)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            _context.Linea.Add(linea);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetLinea", new { id = linea.Id }, linea);
        }

        // DELETE: api/Linea/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteLinea([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var linea = await _context.Linea.SingleOrDefaultAsync(m => m.Id == id);
            if (linea == null)
            {
                return NotFound();
            }

            _context.Linea.Remove(linea);
            await _context.SaveChangesAsync();

            return Ok(linea);
        }

        private bool LineaExists(int id)
        {
            return _context.Linea.Any(e => e.Id == id);
        }
    }
}