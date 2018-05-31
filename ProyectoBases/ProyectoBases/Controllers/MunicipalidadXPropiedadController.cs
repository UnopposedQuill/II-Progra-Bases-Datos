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
    [Route("api/MunicipalidadXPropiedad")]
    public class MunicipalidadXPropiedadController : Controller
    {
        private readonly ProyectoBasesContext _context;

        public MunicipalidadXPropiedadController(ProyectoBasesContext context)
        {
            _context = context;
        }

        // GET: api/MunicipalidadXPropiedad
        [HttpGet]
        public IEnumerable<MunicipalidadXPropiedad> GetMunicipalidadXPropiedad()
        {
            return _context.MunicipalidadXPropiedad;
        }

        // GET: api/MunicipalidadXPropiedad/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetMunicipalidadXPropiedad([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var municipalidadXPropiedad = await _context.MunicipalidadXPropiedad.SingleOrDefaultAsync(m => m.Id == id);

            if (municipalidadXPropiedad == null)
            {
                return NotFound();
            }

            return Ok(municipalidadXPropiedad);
        }

        // PUT: api/MunicipalidadXPropiedad/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutMunicipalidadXPropiedad([FromRoute] int id, [FromBody] MunicipalidadXPropiedad municipalidadXPropiedad)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != municipalidadXPropiedad.Id)
            {
                return BadRequest();
            }

            _context.Entry(municipalidadXPropiedad).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!MunicipalidadXPropiedadExists(id))
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

        // POST: api/MunicipalidadXPropiedad
        [HttpPost]
        public async Task<IActionResult> PostMunicipalidadXPropiedad([FromBody] MunicipalidadXPropiedad municipalidadXPropiedad)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            _context.MunicipalidadXPropiedad.Add(municipalidadXPropiedad);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetMunicipalidadXPropiedad", new { id = municipalidadXPropiedad.Id }, municipalidadXPropiedad);
        }

        // DELETE: api/MunicipalidadXPropiedad/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteMunicipalidadXPropiedad([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var municipalidadXPropiedad = await _context.MunicipalidadXPropiedad.SingleOrDefaultAsync(m => m.Id == id);
            if (municipalidadXPropiedad == null)
            {
                return NotFound();
            }

            _context.MunicipalidadXPropiedad.Remove(municipalidadXPropiedad);
            await _context.SaveChangesAsync();

            return Ok(municipalidadXPropiedad);
        }

        private bool MunicipalidadXPropiedadExists(int id)
        {
            return _context.MunicipalidadXPropiedad.Any(e => e.Id == id);
        }
    }
}