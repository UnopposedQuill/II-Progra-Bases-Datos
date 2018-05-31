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
    [Route("api/Recibo")]
    public class ReciboController : Controller
    {
        private readonly ProyectoBasesContext _context;

        public ReciboController(ProyectoBasesContext context)
        {
            _context = context;
        }

        // GET: api/Recibo
        [HttpGet]
        public IEnumerable<Recibo> GetRecibo()
        {
            return _context.Recibo;
        }

        // GET: api/Recibo/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetRecibo([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var recibo = await _context.Recibo.SingleOrDefaultAsync(m => m.Id == id);

            if (recibo == null)
            {
                return NotFound();
            }

            return Ok(recibo);
        }

        // PUT: api/Recibo/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutRecibo([FromRoute] int id, [FromBody] Recibo recibo)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != recibo.Id)
            {
                return BadRequest();
            }

            _context.Entry(recibo).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ReciboExists(id))
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

        // POST: api/Recibo
        [HttpPost]
        public async Task<IActionResult> PostRecibo([FromBody] Recibo recibo)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            _context.Recibo.Add(recibo);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetRecibo", new { id = recibo.Id }, recibo);
        }

        // DELETE: api/Recibo/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteRecibo([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var recibo = await _context.Recibo.SingleOrDefaultAsync(m => m.Id == id);
            if (recibo == null)
            {
                return NotFound();
            }

            _context.Recibo.Remove(recibo);
            await _context.SaveChangesAsync();

            return Ok(recibo);
        }

        private bool ReciboExists(int id)
        {
            return _context.Recibo.Any(e => e.Id == id);
        }
    }
}