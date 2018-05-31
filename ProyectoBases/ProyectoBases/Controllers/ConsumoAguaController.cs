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
    [Route("api/ConsumoAgua")]
    public class ConsumoAguaController : Controller
    {
        private readonly ProyectoBasesContext _context;

        public ConsumoAguaController(ProyectoBasesContext context)
        {
            _context = context;
        }

        // GET: api/ConsumoAgua
        [HttpGet]
        public IEnumerable<ConsumoAgua> GetConsumoAgua()
        {
            return _context.ConsumoAgua;
        }

        // GET: api/ConsumoAgua/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetConsumoAgua([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var consumoAgua = await _context.ConsumoAgua.SingleOrDefaultAsync(m => m.Id == id);

            if (consumoAgua == null)
            {
                return NotFound();
            }

            return Ok(consumoAgua);
        }

        // PUT: api/ConsumoAgua/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutConsumoAgua([FromRoute] int id, [FromBody] ConsumoAgua consumoAgua)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != consumoAgua.Id)
            {
                return BadRequest();
            }

            _context.Entry(consumoAgua).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ConsumoAguaExists(id))
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

        // POST: api/ConsumoAgua
        [HttpPost]
        public async Task<IActionResult> PostConsumoAgua([FromBody] ConsumoAgua consumoAgua)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            _context.ConsumoAgua.Add(consumoAgua);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetConsumoAgua", new { id = consumoAgua.Id }, consumoAgua);
        }

        // DELETE: api/ConsumoAgua/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteConsumoAgua([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var consumoAgua = await _context.ConsumoAgua.SingleOrDefaultAsync(m => m.Id == id);
            if (consumoAgua == null)
            {
                return NotFound();
            }

            _context.ConsumoAgua.Remove(consumoAgua);
            await _context.SaveChangesAsync();

            return Ok(consumoAgua);
        }

        private bool ConsumoAguaExists(int id)
        {
            return _context.ConsumoAgua.Any(e => e.Id == id);
        }
    }
}