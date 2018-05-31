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
    [Route("api/Municipalidad")]
    public class MunicipalidadController : Controller
    {
        private readonly ProyectoBasesContext _context;

        public MunicipalidadController(ProyectoBasesContext context)
        {
            _context = context;
        }

        // GET: api/Municipalidad
        [HttpGet]
        public IEnumerable<Municipalidad> GetMunicipalidad()
        {
            return _context.Municipalidad;
        }

        // GET: api/Municipalidad/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetMunicipalidad([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var municipalidad = await _context.Municipalidad.SingleOrDefaultAsync(m => m.Id == id);

            if (municipalidad == null)
            {
                return NotFound();
            }

            return Ok(municipalidad);
        }

        // PUT: api/Municipalidad/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutMunicipalidad([FromRoute] int id, [FromBody] Municipalidad municipalidad)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != municipalidad.Id)
            {
                return BadRequest();
            }

            _context.Entry(municipalidad).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!MunicipalidadExists(id))
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

        // POST: api/Municipalidad
        [HttpPost]
        public async Task<IActionResult> PostMunicipalidad([FromBody] Municipalidad municipalidad)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            _context.Municipalidad.Add(municipalidad);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetMunicipalidad", new { id = municipalidad.Id }, municipalidad);
        }

        // DELETE: api/Municipalidad/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteMunicipalidad([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var municipalidad = await _context.Municipalidad.SingleOrDefaultAsync(m => m.Id == id);
            if (municipalidad == null)
            {
                return NotFound();
            }

            _context.Municipalidad.Remove(municipalidad);
            await _context.SaveChangesAsync();

            return Ok(municipalidad);
        }

        private bool MunicipalidadExists(int id)
        {
            return _context.Municipalidad.Any(e => e.Id == id);
        }
    }
}