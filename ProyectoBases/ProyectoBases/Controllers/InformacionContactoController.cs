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
    [Route("api/InformacionContacto")]
    public class InformacionContactoController : Controller
    {
        private readonly ProyectoBasesContext _context;

        public InformacionContactoController(ProyectoBasesContext context)
        {
            _context = context;
        }

        // GET: api/InformacionContacto
        [HttpGet]
        public IEnumerable<InformacionContacto> GetInformacionContacto()
        {
            return _context.InformacionContacto;
        }

        // GET: api/InformacionContacto/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetInformacionContacto([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var informacionContacto = await _context.InformacionContacto.SingleOrDefaultAsync(m => m.Id == id);

            if (informacionContacto == null)
            {
                return NotFound();
            }

            return Ok(informacionContacto);
        }

        // PUT: api/InformacionContacto/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutInformacionContacto([FromRoute] int id, [FromBody] InformacionContacto informacionContacto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != informacionContacto.Id)
            {
                return BadRequest();
            }

            _context.Entry(informacionContacto).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!InformacionContactoExists(id))
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

        // POST: api/InformacionContacto
        [HttpPost]
        public async Task<IActionResult> PostInformacionContacto([FromBody] InformacionContacto informacionContacto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            _context.InformacionContacto.Add(informacionContacto);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetInformacionContacto", new { id = informacionContacto.Id }, informacionContacto);
        }

        // DELETE: api/InformacionContacto/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteInformacionContacto([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var informacionContacto = await _context.InformacionContacto.SingleOrDefaultAsync(m => m.Id == id);
            if (informacionContacto == null)
            {
                return NotFound();
            }

            _context.InformacionContacto.Remove(informacionContacto);
            await _context.SaveChangesAsync();

            return Ok(informacionContacto);
        }

        private bool InformacionContactoExists(int id)
        {
            return _context.InformacionContacto.Any(e => e.Id == id);
        }
    }
}