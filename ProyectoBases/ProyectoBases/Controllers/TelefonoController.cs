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
    [Route("api/Telefono")]
    public class TelefonoController : Controller
    {
        private readonly ProyectoBasesContext _context;

        public TelefonoController(ProyectoBasesContext context)
        {
            _context = context;
        }

        // GET: api/Telefono
        [HttpGet]
        public IEnumerable<Telefono> GetTelefono()
        {
            return _context.Telefono;
        }

        // GET: api/Telefono/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetTelefono([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var telefono = await _context.Telefono.SingleOrDefaultAsync(m => m.Id == id);

            if (telefono == null)
            {
                return NotFound();
            }

            return Ok(telefono);
        }

        // PUT: api/Telefono/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutTelefono([FromRoute] int id, [FromBody] Telefono telefono)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != telefono.Id)
            {
                return BadRequest();
            }

            _context.Entry(telefono).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!TelefonoExists(id))
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

        // POST: api/Telefono
        [HttpPost]
        public async Task<IActionResult> PostTelefono([FromBody] Telefono telefono)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            _context.Telefono.Add(telefono);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetTelefono", new { id = telefono.Id }, telefono);
        }

        // DELETE: api/Telefono/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTelefono([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var telefono = await _context.Telefono.SingleOrDefaultAsync(m => m.Id == id);
            if (telefono == null)
            {
                return NotFound();
            }

            _context.Telefono.Remove(telefono);
            await _context.SaveChangesAsync();

            return Ok(telefono);
        }

        private bool TelefonoExists(int id)
        {
            return _context.Telefono.Any(e => e.Id == id);
        }
    }
}