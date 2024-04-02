using NUnit.Framework.Internal.Execution;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Temalab2
{
    public partial class Form1 : Form
    {
        public object Event { get; private set; }

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            monthCalendar1.MaxSelectionCount = 1; //pun egal cu 1 ca sa se poata selecta o singura data
        }

        private void button1_Click(object sender, EventArgs e)
        {
            string titlueveniment = label2.Text;
            if(string.IsNullOrWhiteSpace(titlueveniment))
            {
                MessageBox.Show("Introduceti un titlu pentru eveniment", "Eroare");
                return;
            }

            string dataEveniment = monthCalendar1.SelectionStart.ToShortDateString();
            if(listBox1.Items.Contains(dataEveniment))
            {
                MessageBox.Show("Evenimentul pentru aceasta data a fost deja adaugat ", "Eroare");
                return;
            }
            listBox1.Items.Add(dataEveniment+ "-"+titlueveniment+(checkBox1.Checked));
            label2.Text = "";
            checkBox1.Checked = false;

            MessageBox.Show("Evenimentul a fost adaugat cu succes", "Succes");
            return;


        }

        private void button2_Click(object sender, EventArgs e)
        {
            if(listBox1.SelectedIndex !=-1) // verific daca s a selectat un element
            {
                listBox1.Items.RemoveAt(listBox1.SelectedIndex);
                MessageBox.Show("Evenimentul a fos sters");
                return;
            }
            else
            {
                MessageBox.Show("Selectati un eveniment pentr a-l sterge");
                return;
            }

        }

        private void monthCalendar1_DateChanged(object sender, DateRangeEventArgs e)
        {
            label1.Text = monthCalendar1.SelectionStart.ToShortDateString();
        }

        private void label2_Click(object sender, EventArgs e)
        {

        }
    }
}
