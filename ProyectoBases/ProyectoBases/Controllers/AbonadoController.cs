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
    [Route("api/Abonado")]
    public class AbonadoController : Controller
    {
        private readonly ProyectoBasesContext _context;

        public AbonadoController(ProyectoBasesContext context)
        {
            _context = context;
        }

        // GET: api/Abonado
        [HttpGet]
        public IEnumerable<Abonado> GetAbonado()
        {
            return _context.Abonado;
        }

        // GET: api/Abonado/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetAbonado([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var abonado = await _context.Abonado.SingleOrDefaultAsync(m => m.Id == id);

            if (abonado == null)
            {
                return NotFound();
            }

            return Ok(abonado);
        }

        // PUT: api/Abonado/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutAbonado([FromRoute] int id, [FromBody] Abonado abonado)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != abonado.Id)
            {
                return BadRequest();
            }

            _context.Entry(abonado).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!AbonadoExists(id))
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

        // POST: api/Abonado
        [HttpPost]
        public async Task<IActionResult> PostAbonado([FromBody] Abonado abonado)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            _context.Abonado.Add(abonado);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetAbonado", new { id = abonado.Id }, abonado);
        }

        // DELETE: api/Abonado/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAbonado([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var abonado = await _context.Abonado.SingleOrDefaultAsync(m => m.Id == id);
            if (abonado == null)
            {
                return NotFound();
            }

            _context.Abonado.Remove(abonado);
            await _context.SaveChangesAsync();

            return Ok(abonado);
        }

        private bool AbonadoExists(int id)
        {
            return _context.Abonado.Any(e => e.Id == id);
        }
    }
}