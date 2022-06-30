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
    public class DatesFirstRenderedsController : ControllerBase
    {
        private readonly PPPDContext _context;

        public DatesFirstRenderedsController(PPPDContext context)
        {
            _context = context;
        }

        // GET: api/DatesFirstRendereds
        [HttpGet]
        public async Task<ActionResult<IEnumerable<DatesFirstRendered>>> GetDatesFirstRendereds()
        {
            return await _context.DatesFirstRendereds.ToListAsync();
        }

        // GET: api/DatesFirstRendereds/5
        [HttpGet("{id}")]
        public async Task<ActionResult<DatesFirstRendered>> GetDatesFirstRendered(int? id)
        {
            var datesFirstRendered = await _context.DatesFirstRendereds.FindAsync(id);

            if (datesFirstRendered == null)
            {
                return NotFound();
            }

            return datesFirstRendered;
        }

        // PUT: api/DatesFirstRendereds/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutDatesFirstRendered(int? id, [FromBody] DatesFirstRendered datesFirstRendered)
        {
            if (id != datesFirstRendered.IdDateFirstRendered)
            {
                return BadRequest();
            }

            _context.Entry(datesFirstRendered).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!DatesFirstRenderedExists(id))
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

        // POST: api/DatesFirstRendereds
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<DatesFirstRendered>> PostDatesFirstRendered([FromBody] DatesFirstRendered datesFirstRendered)
        {
            _context.DatesFirstRendereds.Add(datesFirstRendered);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetDatesFirstRendered", new { id = datesFirstRendered.IdDateFirstRendered }, datesFirstRendered);
        }

        // DELETE: api/DatesFirstRendereds/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<DatesFirstRendered>> DeleteDatesFirstRendered(int? id)
        {
            var datesFirstRendered = await _context.DatesFirstRendereds.FindAsync(id);
            if (datesFirstRendered == null)
            {
                return NotFound();
            }

            _context.DatesFirstRendereds.Remove(datesFirstRendered);
            await _context.SaveChangesAsync();

            return datesFirstRendered;
        }

        private bool DatesFirstRenderedExists(int? id)
        {
            return _context.DatesFirstRendereds.Any(e => e.IdDateFirstRendered == id);
        }
    }
}
