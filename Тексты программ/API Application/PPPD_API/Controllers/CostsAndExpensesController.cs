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
    public class CostsAndExpensesController : ControllerBase
    {
        private readonly PPPDContext _context;

        public CostsAndExpensesController(PPPDContext context)
        {
            _context = context;
        }

        // GET: api/CostsAndExpenses
        [HttpGet]
        public async Task<ActionResult<IEnumerable<CostsAndExpense>>> GetCostsAndExpenses()
        {
            return await _context.CostsAndExpenses.ToListAsync();
        }

        // GET: api/CostsAndExpenses/5
        [HttpGet("{id}")]
        public async Task<ActionResult<CostsAndExpense>> GetCostsAndExpense(int? id)
        {
            var costsAndExpense = await _context.CostsAndExpenses.FindAsync(id);

            if (costsAndExpense == null)
            {
                return NotFound();
            }

            return costsAndExpense;
        }

        // PUT: api/CostsAndExpenses/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutCostsAndExpense(int? id, [FromBody] CostsAndExpense costsAndExpense)
        {
            if (id != costsAndExpense.IdCostsAndExpenses)
            {
                return BadRequest();
            }

            _context.Entry(costsAndExpense).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CostsAndExpenseExists(id))
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

        // POST: api/CostsAndExpenses
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<CostsAndExpense>> PostCostsAndExpense([FromBody] CostsAndExpense costsAndExpense)
        {
            _context.CostsAndExpenses.Add(costsAndExpense);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetCostsAndExpense", new { id = costsAndExpense.IdCostsAndExpenses }, costsAndExpense);
        }

        // DELETE: api/CostsAndExpenses/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<CostsAndExpense>> DeleteCostsAndExpense(int? id)
        {
            var costsAndExpense = await _context.CostsAndExpenses.FindAsync(id);
            if (costsAndExpense == null)
            {
                return NotFound();
            }

            _context.CostsAndExpenses.Remove(costsAndExpense);
            await _context.SaveChangesAsync();

            return costsAndExpense;
        }

        private bool CostsAndExpenseExists(int? id)
        {
            return _context.CostsAndExpenses.Any(e => e.IdCostsAndExpenses == id);
        }
    }
}
