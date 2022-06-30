using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PPPD_API.Models;

namespace PPPD_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CabinetnsController : ControllerBase
    {
        private readonly PPPDContext _context;

        public CabinetnsController(PPPDContext context)
        {
            _context = context;
        }

        // GET: api/Cabinetns
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Cabinetn>>> GetCabinetns()
        {
            return await _context.Cabinetns.ToListAsync();
        }

        // GET: api/Cabinetns/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Cabinetn>> GetCabinetn(int? id)
        {
            var cabinetn = await _context.Cabinetns.FindAsync(id);

            if (cabinetn == null)
            {
                return NotFound();
            }

            return cabinetn;
        }

        // PUT: api/Cabinetns/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutCabinetn(int? id, [FromBody] Cabinetn cabinetn)
        {
            if (id != cabinetn.IdCabinet)
            {
                return BadRequest();
            }

            _context.Entry(cabinetn).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CabinetnExists(id))
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

        // POST: api/Cabinetns
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<Cabinetn>> PostCabinetn([FromBody] Cabinetn cabinetn)
        {
            _context.Cabinetns.Add(cabinetn);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetCabinetn", new { id = cabinetn.IdCabinet }, cabinetn);
        }

        // DELETE: api/Cabinetns/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Cabinetn>> DeleteCabinetn(int? id)
        {
            var cabinetn = await _context.Cabinetns.FindAsync(id);
            if (cabinetn == null)
            {
                return NotFound();
            }

            _context.Cabinetns.Remove(cabinetn);
            await _context.SaveChangesAsync();

            return cabinetn;
        }

        private bool CabinetnExists(int? id)
        {
            return _context.Cabinetns.Any(e => e.IdCabinet == id);
        }
    }
}
